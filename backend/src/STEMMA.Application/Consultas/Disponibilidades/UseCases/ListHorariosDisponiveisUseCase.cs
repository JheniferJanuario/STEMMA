using STEMMA.Application.Consultas.Disponibilidades.DTOs.Responses;
using STEMMA.Domain.Consultas.Enums;
using STEMMA.Domain.Consultas.Repositories;

namespace STEMMA.Application.Consultas.Disponibilidades.UseCases;

public class ListHorariosDisponiveisUseCase
{
    private readonly IDisponibilidadeRepository _disponibilidadeRepository;
    private readonly IConsultaRepository _consultaRepository;

    public ListHorariosDisponiveisUseCase(
        IDisponibilidadeRepository disponibilidadeRepository,
        IConsultaRepository consultaRepository)
    {
        _disponibilidadeRepository = disponibilidadeRepository;
        _consultaRepository = consultaRepository;
    }

    public async Task<List<HorarioDisponivelResponse>> ExecuteAsync(
        Guid veterinarioId,
        DateTime data)
    {
        var inicioDia = data.Date;
        var fimDia = inicioDia.AddDays(1);

        var disponibilidades =
            await _disponibilidadeRepository.ObterPorPeriodoAsync(
                veterinarioId,
                inicioDia,
                fimDia);

        var consultas =
            await _consultaRepository.ObterPorVeterinarioEPeriodoAsync(
                veterinarioId,
                inicioDia,
                fimDia);

        var consultasAgendadas = consultas
            .Where(x => x.Status == StatusConsulta.Agendada)
            .ToList();

        var horariosLivres = new List<HorarioDisponivelResponse>();

        foreach (var disponibilidade in disponibilidades)
        {
            var ocupado = consultasAgendadas.Any(c =>
                c.DataConsulta >= disponibilidade.DataInicio &&
                c.DataConsulta < disponibilidade.DataFim);

            if (!ocupado)
            {
                horariosLivres.Add(new HorarioDisponivelResponse
                {
                    Inicio = disponibilidade.DataInicio,
                    Fim = disponibilidade.DataFim
                });
            }
        }

        return horariosLivres
            .OrderBy(x => x.Inicio)
            .ToList();
    }
}