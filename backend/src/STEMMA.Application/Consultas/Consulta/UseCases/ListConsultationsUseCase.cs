using STEMMA.Application.Consultas.DTOs.Responses;
using STEMMA.Domain.Consultas.Repositories;

namespace STEMMA.Application.Consultas.UseCases;

public class ListConsultationsUseCase
{
    private readonly IConsultaRepository _consultaRepository;

    public ListConsultationsUseCase(IConsultaRepository consultaRepository)
    {
        _consultaRepository = consultaRepository;
    }

    public async Task<List<ConsultationResponse>> ExecuteAsync()
    {
        var consultas = await _consultaRepository.ListarAsync();

        return consultas.Select(c => new ConsultationResponse
        {
            Id = c.Id,
            PetId = c.PetId,
            VeterinarianId = c.VeterinarioId,
            DateTime = c.DataConsulta,
            Status = c.Status.ToString()
        }).ToList();
    }
}