using STEMMA.Application.Consultas.Mappers;
using STEMMA.Application.Consultas.DTOs.Responses;
using STEMMA.Domain.Consultas.Repositories;

namespace STEMMA.Application.Consultas.UseCases;

public class ListClosedConsultationsUseCase
{
    private readonly IConsultaRepository _consultaRepository;

    public ListClosedConsultationsUseCase(
        IConsultaRepository consultaRepository)
    {
        _consultaRepository = consultaRepository;
    }

    public async Task<List<ConsultationResponse>> ExecuteAsync()
    {
        var consultas =
            await _consultaRepository.ObterEncerradasAsync();

        return ConsultaMapper.ParaListaResposta(consultas);
    }
}